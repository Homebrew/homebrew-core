class Termsql < Formula
  desc "Convert text into SQL table and query it"
  homepage "https://tobimensch.github.io/termsql/"
  url "https://github.com/tobimensch/termsql.git"
  version "0.3"

  depends_on :python => ["sqlite3", "sqlparse"]

  def install
    # Replace path to man pages in hard-coded setup.py
    inreplace "setup.py", %r{/usr/share/man/man1/}, man1

    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    # Run an example query (count processes)
    system "ls -lha /usr/bin/* | termsql -w -r 8 \"select count(*) from tbl\""
  end
end
