class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.19-cutoff.tar.gz"
  sha256 "a4aa19783eb167ee0c744344048990c526ef4f04ede4c6aefbd421d3aa152c7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a61e6be1b549ae566f3ff6654fc0fe9a3fc8ffcaca3380f46bf70cdce9da8e" => :el_capitan
    sha256 "8659deb78e3bc779bb6b94fdb9314f418487581ffe538c1021da4e6b0f11a8ed" => :yosemite
    sha256 "407509efbcdc2292c97bfbe82623eb89b74b3afd5cc52df8eb0d5714a8228c11" => :mavericks
  end

  depends_on "gradle" => :build
  depends_on :java => "1.7+"

  def install
    ENV.java_cache
    system "./gradlew", "build", "-x", "test"
    libexec.install %w[lib dist contrib]
    bin.install Dir["bin/*{.sh,.py}"]
    libexec.install "bin"
    pkgshare.install "config" => "config-examples"
    (etc/"voldemort").mkpath
    env = {
      :VOLDEMORT_HOME => libexec,
      :VOLDEMORT_CONFIG_DIR => etc/"voldemort",
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"vadmin.sh"
  end
end
