class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.4.tar.gz"
  sha256 "ad066b48565e82208d5e0451891366f6a9b9a3648d149d14c83d00f4712094d3"
  revision 1
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    rebuild 1
    sha256 "dabc92a0af95e91c9257803ef547b1d2ce6cf59f950893b34106fb73098ce32e" => :mojave
    sha256 "474e42470e4b10fde9c416f985120273acb909a17fea63c76a291c448f0153b4" => :high_sierra
    sha256 "85ef3d390772979703100fb42db28c944860728075f6ff49bacb917d95754097" => :sierra
    sha256 "6170bf76495f5826c18dc2d8ffd61bf3ca0064617f58701e63e806abf10106c2" => :el_capitan
  end

  depends_on "ruby"

  def install
    inreplace "lib/common/common_helper.rb" do |s|
      s.gsub! "File.join(USER_DIR, '.wpscan/cache')", "'#{var}/cache/wpscan'"
      s.gsub! "File.join(USER_DIR, '.wpscan/data')", "'#{var}/wpscan/data'"
      s.gsub! "File.join(USER_DIR, '.wpscan/log.txt')", "'#{var}/log/wpscan/log.txt'"
    end

    system "unzip", "-o", "data.zip"
    libexec.install "data", "lib", "spec", "Gemfile", "Gemfile.lock", "wpscan.rb"

    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    system "gem", "install", "bundler"
    bundle = Dir["#{libexec}/**/bundle"].last
    system bundle, "install", "--without", "test"

    (bin/"wpscan").write <<~EOS
      #!/bin/bash
      GEM_HOME="#{libexec}" BUNDLE_GEMFILE="#{libexec}/Gemfile" \\
        exec "#{bundle}" exec "#{Formula["ruby"].opt_bin}/ruby" \\
        "#{libexec}/wpscan.rb" "$@"
    EOS
  end

  def post_install
    (var/"log/wpscan").mkpath
    # Update database
    system bin/"wpscan", "--update"
  end

  def caveats; <<~EOS
    Logs are saved to #{var}/cache/wpscan/log.txt by default.
  EOS
  end

  test do
    assert_match "URL: https://wordpress.org/",
                 pipe_output("#{bin}/wpscan --url https://wordpress.org/")
  end
end
