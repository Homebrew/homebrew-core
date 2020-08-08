class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/v3.8.6.tar.gz"
  sha256 "d848ef5a99e508ee981d66cdc6b30c145a75202c30eda3a870571fd8a80d5333"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    cellar :any
    sha256 "14bd70ea9ed75109bc30e783ff69941caf78d4b47b877bde672509fd79cd626c" => :catalina
    sha256 "72e20f9efd1376876936c04b52fb818b2be4b36b039fca6af44af277d5838e12" => :mojave
    sha256 "9b52f17b8d943cc8c5f18bb813ed800b5e603eb42aabcd90baa46c787b98785f" => :high_sierra
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
