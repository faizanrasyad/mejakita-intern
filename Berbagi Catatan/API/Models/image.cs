﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace BerbagiCatatanSwagger.Models;

public partial class image
{
    public int id { get; set; }

    public string image1 { get; set; }

    public int? catatanId { get; set; }

    public virtual catatan catatan { get; set; }
}