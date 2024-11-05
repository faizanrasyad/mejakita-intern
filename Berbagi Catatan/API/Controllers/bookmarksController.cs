using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BerbagiCatatanSwagger.Models;
using Microsoft.EntityFrameworkCore.Internal;
using Swashbuckle.AspNetCore.Annotations;

namespace BerbagiCatatanSwagger.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class bookmarksController : ControllerBase
    {
        private readonly BerbagiCatatanContext _context;

        public bookmarksController(BerbagiCatatanContext context)
        {
            _context = context;
        }

        // POST: /api/addbookmark (Tambah bookmark lebih mudah)
        [Route("/api/addbookmark")]
        [HttpPost]
        [SwaggerOperation(Summary = "Bookmark catatan", Description = "Tambahkan catatan ke daftar catatan yang di bookmark")]
        [SwaggerResponse(200, "Catatan berhasil ditambahkan ke daftar catatan yang di bookmark.")]
        [SwaggerResponse(404, "Catatan gagal ditambahkan ke daftar catatan yang di bookmark.")]
        public async Task<ActionResult<bookmark>> addBookmark(int userId, int catatanId)
        {
            bookmark newBookmark = new bookmark();
            newBookmark.userId = userId;
            newBookmark.catatanId = catatanId;

            int initBookmarkLength = _context.bookmarks.Count();

            _context.bookmarks.Add(newBookmark);
            await _context.SaveChangesAsync();

            int newBookmarkLength = _context.bookmarks.Count();

            if (newBookmarkLength > initBookmarkLength)
            {
                var savedBookmark = await _context.bookmarks.FindAsync(newBookmarkLength);
                return CreatedAtAction("Getbookmark", new { id = savedBookmark!.id }, savedBookmark);
            }

            return BadRequest();
            
        }

        // DELETE: api/removeBookmark (Hapus bookmark lebih mudah)
        [Route("/api/removebookmark")]
        [HttpDelete]
        [SwaggerOperation(Summary = "Hapus bookmark catatan", Description = "Hapus catatan dari daftar catatan yang di bookmark")]
        [SwaggerResponse(200, "Catatan berhasil dihapus dari daftar catatan yang di bookmark.")]
        [SwaggerResponse(404, "Catatan gagal dihapus dari daftar catatan yang di bookmark.")]
        public async Task<IActionResult> removeBookmark(int userId, int catatanId)
        {
            var bookmark = await _context.bookmarks.FirstOrDefaultAsync(r=> r.userId.Equals(userId) && r.catatanId.Equals(catatanId));

            if (bookmark == null)
            {
                return NotFound();
            }

            _context.bookmarks.Remove(bookmark);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        //// GET: api/bookmarks
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<bookmark>>> Getbookmarks()
        //{
        //    return await _context.bookmarks.ToListAsync();
        //}

        //// GET: api/bookmarks/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<bookmark>> Getbookmark(int id)
        //{
        //    var bookmark = await _context.bookmarks.FindAsync(id);

        //    if (bookmark == null)
        //    {
        //        return NotFound();
        //    }

        //    return bookmark;
        //}

        //// PUT: api/bookmarks/5
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> Putbookmark(int id, bookmark bookmark)
        //{
        //    if (id != bookmark.id)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(bookmark).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!bookmarkExists(id))
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

        //// POST: api/bookmarks
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<bookmark>> Postbookmark(bookmark bookmark)
        //{
        //    _context.bookmarks.Add(bookmark);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("Getbookmark", new { id = bookmark.id }, bookmark);
        //}

        //// DELETE: api/bookmarks/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> Deletebookmark(int id)
        //{
        //    var bookmark = await _context.bookmarks.FindAsync(id);
        //    if (bookmark == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.bookmarks.Remove(bookmark);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        private bool bookmarkExists(int id)
        {
            return _context.bookmarks.Any(e => e.id == id);
        }
    }
}
