using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class TrustLevels
    {
        public long Id { get; set; }
        public string Explanation { get; set; }
        public DateTime CreateDateAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long? LastModifiedByMemberId { get; set; }
        public DateTime? LastModifiedAt { get; set; }
        public string Name { get; set; }
    }
}
