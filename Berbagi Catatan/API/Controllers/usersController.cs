using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BerbagiCatatanSwagger.Models;
using Swashbuckle.AspNetCore.Annotations;
using Microsoft.AspNetCore.Authorization;

namespace BerbagiCatatanSwagger.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class usersController : ControllerBase
    {
        private readonly BerbagiCatatanContext _context;

        public usersController(BerbagiCatatanContext context)
        {
            _context = context;
        }

        [Route("/api/login")]
        [HttpPost]
        [SwaggerOperation(Summary = "User Login", Description = "Login user dengan memvalidasi username dan password.")]
        [SwaggerResponse(200, "User berhasil login.")]
        [SwaggerResponse(404, "User tidak ditemukan.")]
        public async Task<ActionResult<user>> login(String username, String password)
        {
            var user = _context.users.Where(r=> r.username.Equals(username) && r.password.Equals(password)).FirstOrDefault();

            if (user == null)
            {
                return NotFound();
            }

            return Ok(user);

        }

        //// GET: api/users
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<user>>> Getusers()
        //{
        //    return await _context.users.ToListAsync();
        //}

        // GET: api/users/5
        [Authorize]
        [HttpGet("{id}")]
        [SwaggerOperation(Summary = "Dapatkan satu user by id", Description = "Fetch satu user dengan memanggil id nya. ()")]
        [SwaggerResponse(200, "User didapatkan.")]
        [SwaggerResponse(404, "User tidak ditemukan.")]
        public async Task<ActionResult<user>> Getuser(int id)
        {
            var user = await _context.users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        // PUT: api/users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> Putuser(int id, user user)
        //{
        //    if (id != user.id)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(user).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!userExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return NoContent();
        //}

        // POST: api/users
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [SwaggerOperation(Summary = "Tambah User", Description = "Menambahkan user dengan memasukkan object user.")]
        [SwaggerResponse(200, "User berhasil ditambahkan.")]
        [SwaggerResponse(404, "User gagal ditambahkan.")]
        public async Task<ActionResult<user>> Postuser(user user)
        {
            _context.users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getuser", new { id = user.id }, user);
        }

        //// DELETE: api/users/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> Deleteuser(int id)
        //{
        //    var user = await _context.users.FindAsync(id);
        //    if (user == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.users.Remove(user);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        private bool userExists(int id)
        {
            return _context.users.Any(e => e.id == id);
        }
    }
}
