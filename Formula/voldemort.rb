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
    cellar :any_skip_relocation
    sha256 "0470f59cbc9dadeff4f18bafddc19f09a81f536bbdcf494982f119451d927bc6" => :catalina
    sha256 "1c6b5439d0223165729b7f036fe7c11892347e600e8f7e1f28e2595121c26c2f" => :mojave
    sha256 "301c2913a8e95fd9e1971cf56867b30ddeded2be1c43664011fa909b772e58bd" => :high_sierra
  end

  depends_on "gradle" => :build
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
