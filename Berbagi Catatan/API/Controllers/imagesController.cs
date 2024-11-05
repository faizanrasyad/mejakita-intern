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
    public class imagesController : ControllerBase
    {
        private readonly BerbagiCatatanContext _context;

        public imagesController(BerbagiCatatanContext context)
        {
            _context = context;
        }

        // GET: api/images (by CatatanId & First)
        [Route("/api/imagebycatatanall")]
        [HttpGet]
        [SwaggerOperation(Summary =  "Fetch semua gambar dari catatan", Description = "Dapatkan semua gambar dari satu catatan - List<Image>")]
        [SwaggerResponse(200, "Gambar berhasil didapatkan.")]
        [SwaggerResponse(404, "Gambar gagal didapatkan.")]
        public async Task<ActionResult<IEnumerable<String>>> Getimagebycatatanall(int catatanId)
        {
            var image = await _context.images.Where(r => r.catatanId == catatanId).Select(r=> r.image1).ToListAsync();

            if (image == null)
            {
                return NotFound();
            }

            return image;
        }

        // GET: api/images (by CatatanId & First)
        [Route("/api/imagebycatatanfirst")]
        [HttpGet]
        [SwaggerOperation(Summary = "Fetch gambar pertama dari catatan", Description = "Dapatkan gambar pertama dari satu catatan - Image")]
        [SwaggerResponse(200, "Gambar berhasil didapatkan.")]
        [SwaggerResponse(404, "Gambar gagal didapatkan.")]
        public async Task<ActionResult<String>> Getimagebycatatanfirst(int catatanId)
        {
            var image = await _context.images.FirstOrDefaultAsync(r => r.catatanId == catatanId);

            if (image == null)
            {
                return NotFound();
            }

            return image.image1;
        }

        //// GET: api/images
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<image>>> Getimages()
        //{
        //    return await _context.images.ToListAsync();
        //}

        //// GET: api/images/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<image>> Getimage(int id)
        //{
        //    var image = await _context.images.FindAsync(id);

        //    if (image == null)
        //    {
        //        return NotFound();
        //    }

        //    return image;
        //}

        // PUT: api/images/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> Putimage(int id, image image)
        //{
        //    if (id != image.id)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(image).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!imageExists(id))
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

        // POST: api/images
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [SwaggerOperation(Summary = "Tambah gambar", Description = "Tambahkan satu gambar")]
        [SwaggerResponse(200, "Gambar berhasil didapatkan.")]
        [SwaggerResponse(404, "Gambar gagal didapatkan.")]
        public async Task<ActionResult<image>> Postimage(image image)
        {
            _context.images.Add(image);
            await _context.SaveChangesAsync();

            return CreatedAtAction("Getimage", new { id = image.id }, image);
        }

        // DELETE: api/images/5
        [HttpDelete("{id}")]
        [SwaggerOperation(Summary = "Hapus gambar", Description = "")]
        [SwaggerResponse(200, "Gambar berhasil didapatkan.")]
        [SwaggerResponse(404, "Gambar gagal didapatkan.")]
        public async Task<IActionResult> Deleteimage(int id)
        {
            var image = await _context.images.FindAsync(id);
            if (image == null)
            {
                return NotFound();
            }

            _context.images.Remove(image);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool imageExists(int id)
        {
            return _context.images.Any(e => e.id == id);
        }
    }
}
