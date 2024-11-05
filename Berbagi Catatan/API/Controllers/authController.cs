using BerbagiCatatanSwagger.Helpers;
using BerbagiCatatanSwagger.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;

namespace BerbagiCatatanSwagger.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class authController : ControllerBase
    {
        private readonly AuthHelpers _authHelpers;

        public authController(AuthHelpers authHelpers)
        {
            _authHelpers = authHelpers;
        }

        [HttpPost("generate-token")]
        [SwaggerOperation(Summary = "Generate bearer token", Description = "Generate bearer token dari object user")]
        public IActionResult GenerateToken([FromBody] user user)
        {
            // Username & Pass !!
            var token = _authHelpers.GenerateJWTToken(user);
            return Ok(new { token });
        }
    }
}
