class StyleCheck < Formula
  desc "Parses latex-formatted text in search of forbidden phrases"
  homepage "https://www.cs.umd.edu/~nspring/software/style-check-readme.html"
  url "https://www.cs.umd.edu/~nspring/software/style-check-0.14.tar.gz"
  sha256 "2ae806fcce9e3b80162c64634422dc32d7f0e6f8a81ba5bc7879358744b4e119"
  license "GPL-2.0-only"
  revision 1

  # The homepage links to an unversioned tarball (style-check-current.tar.gz)
  # and the GitHub repository (https://github.com/nspring/style-check) has no
  # tags.
  livecheck do
    skip "No version information available to check"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fb1e03c25875d0cf1b78f401e403452420169250d6fd6cee1be00d4d8bb51725"
  end

  uses_from_macos "ruby"

  # Fix compatibility with Ruby 3.2.
  # Should be deletable on next release.
  patch :DATA

  def install
    inreplace "style-check.rb", "/etc/style-check.d/", etc/"style-check.d/"
    system "make", "PREFIX=#{prefix}",
                   "SYSCONFDIR=#{etc}/style-check.d",
                   "install"
  end

  test do
    (testpath/".style-censor").write "homebrew % capitalize Homebrew\n"
    (testpath/"paper.tex").write "Today I worked on homebrew\n"

    system bin/"style-check.rb", "-v", "paper.tex"
  end
end
__END__
diff --git a/style-check.rb b/style-check.rb
index 893a59f..43e0e84 100755
--- a/style-check.rb
+++ b/style-check.rb
@@ -163,7 +163,7 @@ def do_cns(line, file, linenum, phra_hash)
     if(detected = phra_hash.keys.detect { |r| m = r.match(line) and (line.index("\n") == nil or m.begin(0) < line.index("\n"))  } ) then
       matchedlines = ( m.end(0) <= ( line.index("\n") or 0 ) ) ? line.gsub(/\n.*/,'') : line.chomp
       puts "%s:%d:%s%d: %s (%s)" % [ file, linenum, Gedit_Mode ? ' ': '', m.begin(0)+1, matchedlines, m.to_s.tr("\n", ' ') ]
-      $exit_status = 1 if(!phra_hash[detected] =~ /\?\s*$/) 
+      $exit_status = 1 if(! /\?\s*$/.match(phra_hash[detected]))
       if($VERBOSE && phra_hash[detected]) then
         puts "  " + phra_hash[detected]
         phra_hash[detected] = nil # don't print the reason more than once

