﻿using DataAccess.Core.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DataAccess.SqlCompact.Results
{
    public class ResultSet
    {
        public Dictionary<string, int> QueryFields { get; set; }
        internal QueryRow _lastRow;
        internal QueryRow _firstRow;
        internal QueryRow _currentRow;

        public IQueryRow CurrentRow { get { return _currentRow; } }
        public IQueryRow FirstRow { get { return _firstRow; } }
        public IQueryRow LastRow { get { return _lastRow; } }

        public int Rows { get; set; }

        public ResultSet()
        {
            Rows = 0;
        }

        public void AddRow(object[] row)
        {
            QueryRow qr = new QueryRow(this, row);
            
            if (FirstRow == null)
            {
                _firstRow = qr;
                _lastRow = qr;
            }
            else
            {
                _lastRow.NextRow = qr;
                _lastRow = qr;
            }

            Rows++;
        }

        public void AddFieldMapping(string field, int location)
        {
            if (QueryFields == null)
                QueryFields = new Dictionary<string, int>();

            field = field.Split('.').Last().Replace("\"", "").ToUpper();
            if (!QueryFields.ContainsKey(field))
                QueryFields.Add(field, location);
        }

        public void SetFields(Dictionary<string, int> maps)
        {
            QueryFields = maps;
        }

        public void NextRow()
        {
            if (_currentRow == null)
               _currentRow = _firstRow;
            else
                _currentRow = _currentRow.NextRow;
        }

        internal void Reset()
        {
            _currentRow = null;
        }
    }
}
