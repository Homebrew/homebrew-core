class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/v3.8.3.tar.gz"
  sha256 "85d8df33c5aa47ea7b86f806e3b929415d97f589d20af66e9969d923d70e33bf"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    cellar :any
    sha256 "202f067c8019102a570f95ac29d60a5010498cedf047e3fb4cd7aab4636f0959" => :catalina
    sha256 "d5cff4f5d3649adab8cd5195266f2e0634d2c8993714f7e59f9d8d8d0bc53dc2" => :mojave
    sha256 "ce604ef3517c146a2922cb3d75ec18d5e740262e5c7b178565e25c07bb410f36" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "xz" # for liblxma
  uses_from_macos "zlib"

  if MacOS.version < :catalina
    depends_on "libffi"
  else
    uses_from_macos "libffi"
  end

  # Fixes the --no-update commandline option
  # https://github.com/wpscanteam/wpscan/pull/1455
  patch do
    url "https://github.com/mistydemeo/wpscan/commit/eed763944642416cb5245b4e0cd281cb161122b4.patch?full_index=1"
    sha256 "0f532dfac5526e75b241e06c17127cd9b608f1450d685a696a2a122e5db545eb"
  end

  def install
    inreplace "lib/wpscan.rb", /DB_DIR.*=.*$/, "DB_DIR = Pathname.new('#{var}/wpscan/db')"
    libexec.install Dir["*"]
    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    system "gem", "install", "bundler"
    bundle = Dir["#{libexec}/**/bundle"].last
    system bundle, "install", "--jobs=#{ENV.make_jobs}"
    wpscan = Dir["#{libexec}/ruby/**/bin/wpscan"].last

    ruby_series = Formula["ruby"].version.to_s.split(".")[0..1].join(".")
    (bin/"wpscan").write <<~EOS
      #!/bin/bash
      GEM_HOME="#{libexec}/ruby/#{ruby_series}.0" BUNDLE_GEMFILE="#{libexec}/Gemfile" \\
        exec "#{bundle}" exec "#{Formula["ruby"].opt_bin}/ruby" \\
        "#{wpscan}" "$@"
    EOS
  end

  def post_install
    # Update database
    system bin/"wpscan", "--update"
  end

  test do
    assert_match "URL: https://wordpress.org/",
                 pipe_output("#{bin}/wpscan --no-update --url https://wordpress.org/")
  end
end
