using BerbagiCatatanSwagger.Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace BerbagiCatatanSwagger.Helpers
{
    public class AuthHelpers
    {
        private readonly IConfiguration _configuration;

        public AuthHelpers(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public String GenerateJWTToken (user user)
        {
            try
            {
                var claims = new List<Claim>
                {
                    new Claim (ClaimTypes.NameIdentifier, user.id.ToString()),
                    new Claim (ClaimTypes.Name, user.name),
                };

                var jwtToken = new JwtSecurityToken(
                    claims: claims,
                    notBefore: DateTime.UtcNow,
                    signingCredentials: new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["ApplicationSettings:JWT_Secret"])),
                    SecurityAlgorithms.HmacSha256Signature
                    ));

                return new JwtSecurityTokenHandler().WriteToken(jwtToken);
            }
            catch (Exception ex) 
            {
                throw new Exception("Error generating JWT Token.", ex);   
            }
        }
    }
}
