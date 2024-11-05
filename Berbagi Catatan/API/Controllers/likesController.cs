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
    public class likesController : ControllerBase
    {
        private readonly BerbagiCatatanContext _context;

        public likesController(BerbagiCatatanContext context)
        {
            _context = context;
        }

        // POST: api/addlike
        [Route("/api/addlike")]
        [HttpPost]
        [SwaggerOperation(Summary = "Like catatan", Description = "Tambahkan catatan ke daftar catatan yang di like")]
        [SwaggerResponse(200, "Catatan berhasil di tambahkan ke daftar like.")]
        [SwaggerResponse(404, "Catatan gagal di tambahkan ke daftar like.")]
        public async Task<ActionResult<like>> addLike(int userId, int catatanId)
        {
            like newLike = new like();
            newLike.userId = userId;
            newLike.catatanId = catatanId;

            int initLikeLength = _context.likes.Count();

            _context.likes.Add(newLike);

            var catatans = await _context.catatans.FindAsync(catatanId);
            catatans!.like_count++;

            await _context.SaveChangesAsync();

            int newLikeLength = _context.likes.Count();

            if (newLikeLength > initLikeLength)
            {
                var savedLike = await _context.likes.FindAsync(newLikeLength);
                return CreatedAtAction("Getlike", new { id = savedLike!.id }, savedLike);
            }            
            
            return BadRequest();
        }

        // DELETE: api/removelike
        [Route("/api/removelike")]
        [HttpDelete]
        [SwaggerOperation(Summary = "Hapus like catatan", Description = "Hapus catatan dari daftar catatan yang di like")]
        [SwaggerResponse(200, "Catatan berhasil di hapus dari daftar like.")]
        [SwaggerResponse(404, "Catatan gagal di hapus dari daftar like.")]
        public async Task<IActionResult> removeLike(int userId, int catatanId)
        {
            var like = await _context.likes.FirstOrDefaultAsync(r=> r.userId.Equals(userId) && r.catatanId.Equals(catatanId));

            if (like == null)
            {
                return NotFound();
            }

            var catatans = await _context.catatans.FindAsync(catatanId);
            catatans!.like_count--;

            _context.likes.Remove(like);

            await _context.SaveChangesAsync();

            return NoContent();
        }

        //// GET: api/likes
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<like>>> Getlikes()
        //{
        //    return await _context.likes.ToListAsync();
        //}

        //// GET: api/likes/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<like>> Getlike(int id)
        //{
        //    var like = await _context.likes.FindAsync(id);

        //    if (like == null)
        //    {
        //        return NotFound();
        //    }

        //    return like;
        //}

        //// PUT: api/likes/5
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> Putlike(int id, like like)
        //{
        //    if (id != like.id)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(like).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!likeExists(id))
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

        //// POST: api/likes
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<like>> Postlike(like like)
        //{
        //    _context.likes.Add(like);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("Getlike", new { id = like.id }, like);
        //}

        //// DELETE: api/likes/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> Deletelike(int id)
        //{
        //    var like = await _context.likes.FindAsync(id);
        //    if (like == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.likes.Remove(like);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        private bool likeExists(int id)
        {
            return _context.likes.Any(e => e.id == id);
        }
    }
}
