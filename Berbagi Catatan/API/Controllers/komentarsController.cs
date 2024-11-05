using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BerbagiCatatanSwagger.Models;
using Swashbuckle.AspNetCore.Annotations;

namespace BerbagiCatatanSwagger.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class komentarsController : ControllerBase
    {
        private readonly BerbagiCatatanContext _context;

        public komentarsController(BerbagiCatatanContext context)
        {
            _context = context;
        }

        // POST: api/addkomentar
        [Route("/api/addkomentar")]
        [HttpPost]
        [SwaggerOperation(Summary = "Tambah komentar", Description = "Tambahkan komentar di catatan")]
        [SwaggerResponse(200, "Komentar berhasil ditambahkan.")]
        [SwaggerResponse(404, "Komentar gagal ditambahkan.")]
        public async Task<ActionResult<komentar>> addKomentar(int userId, int catatanId, String comment)
        {
            komentar newKomentar = new komentar();
            newKomentar.userId = userId;    
            newKomentar.catatanId = catatanId;   
            newKomentar.komentar1 = comment;

            int initKomentarLength = _context.komentars.Count();

            _context.komentars.Add(newKomentar);
            await _context.SaveChangesAsync();

            int newKomentarLength = _context.komentars.Count();

            if (newKomentarLength > initKomentarLength)
            {
                var savedKomentar = await _context.komentars.FindAsync(newKomentarLength);
                return CreatedAtAction("Getkomentar", new { id = savedKomentar!.id }, savedKomentar);
            }

            return BadRequest();
        }

        // DELETE: api/removekomentar
        [Route("/api/removekomentar")]
        [HttpDelete]
        [SwaggerOperation(Summary = "Hapus komentar", Description = "Hapus komentar di catatan")]
        [SwaggerResponse(200, "Komentar berhasil dihapus.")]
        [SwaggerResponse(404, "Komentar gagal dihapus.")]
        public async Task<IActionResult> removeKomentar(int userId, int catatanId, String comment)
        {
            var komentar = await _context.komentars.FirstOrDefaultAsync(r=> r.userId.Equals(userId) && r.catatanId.Equals(catatanId) && r.komentar1.Equals(comment));
            if (komentar == null)
            {
                return NotFound();
            }

            _context.komentars.Remove(komentar);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        //// GET: api/komentars
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<komentar>>> Getkomentars()
        //{
        //    return await _context.komentars.ToListAsync();
        //}

        //// GET: api/komentars/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<komentar>> Getkomentar(int id)
        //{
        //    var komentar = await _context.komentars.FindAsync(id);

        //    if (komentar == null)
        //    {
        //        return NotFound();
        //    }

        //    return komentar;
        //}

        //// PUT: api/komentars/5
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> Putkomentar(int id, komentar komentar)
        //{
        //    if (id != komentar.id)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(komentar).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!komentarExists(id))
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

        //// POST: api/komentars
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<komentar>> Postkomentar(komentar komentar)
        //{
        //    _context.komentars.Add(komentar);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("Getkomentar", new { id = komentar.id }, komentar);
        //}

        //// DELETE: api/komentars/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> Deletekomentar(int id)
        //{
        //    var komentar = await _context.komentars.FindAsync(id);
        //    if (komentar == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.komentars.Remove(komentar);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        private bool komentarExists(int id)
        {
            return _context.komentars.Any(e => e.id == id);
        }
    }
}
