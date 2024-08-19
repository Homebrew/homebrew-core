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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71f97469f73c0728c3b0e318d2b8c7261670e7079a585fa048548c5565a20c51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f0a28d7fa18573dd40579d1c426a439634af2d5f26298a973b105cd0cc07ef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f0a28d7fa18573dd40579d1c426a439634af2d5f26298a973b105cd0cc07ef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f0a28d7fa18573dd40579d1c426a439634af2d5f26298a973b105cd0cc07ef2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b9aa45188655a28e257c10973606919563af46ab2e0491d4a5801305125b55b"
    sha256 cellar: :any_skip_relocation, ventura:        "bcdb0ab170dd1514ce780db40deca17ab9aa8e879d1886b62ea0f5269402b589"
    sha256 cellar: :any_skip_relocation, monterey:       "bcdb0ab170dd1514ce780db40deca17ab9aa8e879d1886b62ea0f5269402b589"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcdb0ab170dd1514ce780db40deca17ab9aa8e879d1886b62ea0f5269402b589"
    sha256 cellar: :any_skip_relocation, catalina:       "bcdb0ab170dd1514ce780db40deca17ab9aa8e879d1886b62ea0f5269402b589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0a28d7fa18573dd40579d1c426a439634af2d5f26298a973b105cd0cc07ef2"
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
    system bin/"ringo", "test.js"
  end
end
