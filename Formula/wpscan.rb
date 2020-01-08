class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.4.tar.gz"
  sha256 "ad066b48565e82208d5e0451891366f6a9b9a3648d149d14c83d00f4712094d3"
  revision 1
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    cellar :any
    sha256 "5a0603a1779b01a55688497b2443ddd639feed2e73e65ae176ce75ba6828ee38" => :catalina
    sha256 "e26e73927d6b65a6ea754407b398afc408737585281840304f6fdca40e32af66" => :mojave
    sha256 "3b73076297580ca90725175015d8ac4ce26caa557f0f2cbbe0392b67ec090905" => :high_sierra
    sha256 "7289430447efb7be22a729ef3d2147702c770984e4b96b61607a06aea8e40ef3" => :sierra
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
