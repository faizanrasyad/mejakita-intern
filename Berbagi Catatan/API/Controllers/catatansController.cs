using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BerbagiCatatanSwagger.Models;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Microsoft.VisualStudio.Web.CodeGeneration.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;

namespace BerbagiCatatanSwagger.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class catatansController : ControllerBase
    {
        private readonly BerbagiCatatanContext _context;

        public catatansController(BerbagiCatatanContext context)
        {
            _context = context;
        }

        // GET: api/userbookmarkcatatan
        [Route("/api/userbookmarkcatatan")]
        [HttpGet]
        [SwaggerOperation(Summary = "Fetch catatan yang di bookmark", Description = "Dapatkan semua catatan yang di boomark oleh user")]
        [SwaggerResponse(200, "Catatan berhasil didapatkan.")]
        [SwaggerResponse(404, "Catatan gagal didapatkan.")]
        public async Task<ActionResult<IEnumerable<catatan>>> Getbookmarksbyuser(int userId)
        {
            var bookmarks = await _context.bookmarks.Where(r => r.userId.Equals(userId)).ToListAsync();

            if (bookmarks == null)
            {
                return NotFound();
            }

            List<catatan> listCatatan = new List<catatan>();

            foreach (var catatanId in bookmarks)
            {
                var newCatatan = await _context.catatans.FindAsync(catatanId);
                listCatatan.Add(newCatatan);
            }

            return listCatatan;
        }

        // GET: api/userlikecatatan
        [Route("/api/userlikecatatan")]
        [HttpGet]
        [SwaggerOperation(Summary = "Fetch catatan yang di like", Description = "Dapatkan semua catatan yang di like oleh user")]
        [SwaggerResponse(200, "Catatan berhasil didapatkan.")]
        [SwaggerResponse(404, "Catatan gagal didapatkan.")]
        public async Task<ActionResult<IEnumerable<catatan>>> Getlikesbyuser(int userId)
        {
            var likes = await _context.likes.Where(r => r.userId.Equals(userId)).Select(r => r.catatanId).ToListAsync();

            if (likes == null)
            {
                return NotFound();
            }

            List<catatan> listCatatan = new List<catatan>();

            foreach (var catatanId in likes)
            {
                var newCatatan = await _context.catatans.FindAsync(catatanId);
                listCatatan.Add(newCatatan);
            }

            return listCatatan;
        }

        // POST: api/addcatatan
        [Route("/api/addcatatan")]
        [HttpPost]
        [SwaggerOperation(Summary = "Tambah catatan", Description = "Tambahkan catatan")]
        [SwaggerResponse(200, "Catatan berhasil ditambahkan.")]
        [SwaggerResponse(404, "Catatan gagal ditambahkan.")]
        public async Task<ActionResult<catatan>> addCatatan(int userId, String name, String description)
        {
            catatan newCatatan = new catatan();
            newCatatan.author = userId;
            newCatatan.name = name;
            newCatatan.description = description;

            int initCatatanLength = _context.catatans.Count();

            _context.catatans.Add(newCatatan);
            await _context.SaveChangesAsync();

            int newCatatanLength = _context.catatans.Count();

            if (newCatatanLength > initCatatanLength)
            {
                var savedCatatan = await _context.catatans.FindAsync(newCatatanLength);
                return CreatedAtAction("Getcatatan", new { id = savedCatatan!.id }, savedCatatan);
            }

            return BadRequest();

        }

        // GET: api/catatans
        [HttpGet]
        [SwaggerOperation(Summary = "Fetch semua catatan", Description = "Dapatkan semua catatan")]
        [SwaggerResponse(200, "Catatan berhasil didapatkan.")]
        [SwaggerResponse(404, "Catatan gagal didapatkan.")]
        public async Task<ActionResult<IEnumerable<catatan>>> Getcatatans()
        {
            return await _context.catatans.ToListAsync();
        }

        // GET: api/catatans/5
        [HttpGet("{id}")]
        [SwaggerOperation(Summary = "Fetch catatan by id", Description = "Dapatkan satu catatan by id")]
        [SwaggerResponse(200, "Catatan berhasil didapatkan.")]
        [SwaggerResponse(404, "Catatan gagal didapatkan.")]
        public async Task<ActionResult<catatan>> Getcatatan(int id)
        {
            var catatan = await _context.catatans.FindAsync(id);

            if (catatan == null)
            {
                return NotFound();
            }

            return catatan;
        }

        // PUT: api/catatans/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        [SwaggerOperation(Summary = "Edit catatan", Description = "Edit catatan ({by id})")]
        [SwaggerResponse(200, "Catatan berhasil di edit.")]
        [SwaggerResponse(404, "Catatan gagal di edit.")]
        public async Task<IActionResult> Putcatatan(int id, catatan catatan)
        {
            if (id != catatan.id)
            {
                return BadRequest();
            }

            _context.Entry(catatan).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!catatanExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        //// POST: api/catatans
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<catatan>> Postcatatan(catatan catatan)
        //{
        //    _context.catatans.Add(catatan);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("Getcatatan", new { id = catatan.id }, catatan);
        //}

        // DELETE: api/catatans/5
        [HttpDelete("{id}")]
        [SwaggerOperation(Summary = "Hapus catatan", Description = "Hapus satu catatan by id")]
        [SwaggerResponse(200, "Catatan berhasil dihapus.")]
        [SwaggerResponse(404, "Catatan gagal dihapus.")]
        public async Task<IActionResult> Deletecatatan(int id)
        {
            var catatan = await _context.catatans.FindAsync(id);
            if (catatan == null)
            {
                return NotFound();
            }

            _context.catatans.Remove(catatan);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool catatanExists(int id)
        {
            return _context.catatans.Any(e => e.id == id);
        }
    }
}
