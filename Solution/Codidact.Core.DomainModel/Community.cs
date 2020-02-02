using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Community
    {
        public Community()
        {
            Question = new HashSet<Question>();
            Tag = new HashSet<Tag>();
        }

        public int Id { get; set; }
        public string Name { get; set; }

        public virtual ICollection<Question> Question { get; set; }
        public virtual ICollection<Tag> Tag { get; set; }
    }
}
