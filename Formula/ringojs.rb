class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v4.0.0/ringojs-4.0.0.tar.gz"
  sha256 "9aea219fc6b4929a7949a34521cb96207073d29aa88f89f9a8833e31e84b14d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b5975c01f8c0407cdbfb815fb7535f9cb008b2dd141446c10f167714bd88f6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b5975c01f8c0407cdbfb815fb7535f9cb008b2dd141446c10f167714bd88f6e"
    sha256 cellar: :any_skip_relocation, monterey:       "6b31c53a9b6168901c52dddfccb9671150401e2a2873f7708c6fce35605bf1e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b31c53a9b6168901c52dddfccb9671150401e2a2873f7708c6fce35605bf1e0"
    sha256 cellar: :any_skip_relocation, catalina:       "6b31c53a9b6168901c52dddfccb9671150401e2a2873f7708c6fce35605bf1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5975c01f8c0407cdbfb815fb7535f9cb008b2dd141446c10f167714bd88f6e"
  end

  depends_on "openjdk@17"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    env = { RINGO_HOME: libexec }
    env.merge! Language::Java.overridable_java_home_env("17")
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    (testpath/"test.js").write <<~EOS
      var x = 40 + 2;
      console.assert(x === 42);
    EOS
    system "#{bin}/ringo", "test.js"
  end
end
