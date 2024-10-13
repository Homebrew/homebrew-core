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
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fdb1ddd59e1f97eb6b776de6710f8bf9dc96c8e9cede250c0a1bdec08475e643"
  end

  depends_on "openjdk@17"

  def install
    rm Dir["bin/*.cmd"]
    rm_r "docker"

    # Ensure bottles are uniform. The `/usr/local` references are all in comments.
    inreplace %w[modules/fs.js modules/globals.js], "/usr/local", HOMEBREW_PREFIX

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    java_env = { RINGO_HOME: libexec }
    java_env.merge! Language::Java.overridable_java_home_env("17")
    bin.env_script_all_files libexec/"bin", java_env
  end

  test do
    (testpath/"test.js").write <<~EOS
      var x = 40 + 2;
      console.assert(x === 42);
    EOS
    system bin/"ringo", "test.js"
  end
end
