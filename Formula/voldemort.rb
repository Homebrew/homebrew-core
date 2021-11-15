class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "https://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.26-cutoff.tar.gz"
  sha256 "8bd41b53c3b903615d281e7277d5a9225075c3d00ea56c6e44d73f6327c73d55"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(/(?:release-)?v?(\d+(?:\.\d+)+)(?:-cutoff)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "dfd48d6516ae04989d577dc18fe490a678c2fccc562d62f9832e2dcc0449a191"
    sha256 cellar: :any_skip_relocation, catalina: "f0b69b617d5a983452c62ad06b316a3faf7ae088528afc492a660d370c120e2f"
    sha256 cellar: :any_skip_relocation, mojave:   "c9b88175b71d839d1afe3d4a3407f982f14f31194065f87bbaff8dbc33198e0b"
  end

  depends_on "gradle" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    system "./gradlew", "build", "-x", "test"
    libexec.install %w[lib dist contrib]
    bin.install Dir["bin/*{.sh,.py}"]
    libexec.install "bin"
    pkgshare.install "config" => "config-examples"
    (etc/"voldemort").mkpath

    env = Language::Java.overridable_java_home_env("1.8")
    env["VOLDEMORT_HOME"] = libexec
    env["VOLDEMORT_CONFIG_DIR"] = etc/"voldemort"
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"vadmin.sh"
  end
end
