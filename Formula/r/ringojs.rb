class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v4.1.0/ringojs-4.1.0.tar.gz"
  sha256 "298fe66f4de3af5bb2971a16c9d6648ab3ee39fed211160802b75901693d8f43"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "3ab47d6d66c7528f9cc7b67be71d428bdab468c46724952615112e03cc50a544"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.cmd"]
    rm_r "docker"

    # Ensure bottles are uniform. The `/usr/local` references are all in comments.
    inreplace %w[modules/fs.js modules/globals.js], "/usr/local", HOMEBREW_PREFIX

    bin.install Dir["bin/*"]
    libexec.install Dir["*"]
    java_env = Language::Java.overridable_java_home_env.merge(RINGO_HOME: libexec)
    bin.env_script_all_files libexec/"bin", java_env
  end

  test do
    (testpath/"test.js").write <<~JS
      var x = 40 + 2;
      console.assert(x === 42);
    JS
    system bin/"ringo", "test.js"
  end
end
