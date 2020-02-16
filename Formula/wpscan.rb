class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/v3.7.8.tar.gz"
  sha256 "4837ca3f8d5d42ca6aa8ccfa61fb3cb8262f050903e6b6d28f747709fea637a5"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    cellar :any
    sha256 "5a0603a1779b01a55688497b2443ddd639feed2e73e65ae176ce75ba6828ee38" => :catalina
    sha256 "e26e73927d6b65a6ea754407b398afc408737585281840304f6fdca40e32af66" => :mojave
    sha256 "3b73076297580ca90725175015d8ac4ce26caa557f0f2cbbe0392b67ec090905" => :high_sierra
    sha256 "7289430447efb7be22a729ef3d2147702c770984e4b96b61607a06aea8e40ef3" => :sierra
  end

  depends_on "ruby"

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
