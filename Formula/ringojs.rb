class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v2.0.0/ringojs-2.0.0.tar.gz"
  sha256 "5991953012f3c493abb8c7256fa48e885bd284976bd1ec36f20fef77ff37fac9"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86b956cc3c7d0279529323450abaf3bca2a61ae520cdc262c44a2ff5035b810c"
    sha256 cellar: :any_skip_relocation, big_sur:       "445095a17c58cb61c8275e174c2630cd4ac2acba61198fdf7fe978544815ad9d"
    sha256 cellar: :any_skip_relocation, catalina:      "445095a17c58cb61c8275e174c2630cd4ac2acba61198fdf7fe978544815ad9d"
    sha256 cellar: :any_skip_relocation, mojave:        "445095a17c58cb61c8275e174c2630cd4ac2acba61198fdf7fe978544815ad9d"
  end

  depends_on "openjdk@11"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    env = { RINGO_HOME: libexec }
    env.merge! Language::Java.overridable_java_home_env("11")
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
