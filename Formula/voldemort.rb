class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.22-cutoff.tar.gz"
  sha256 "7b6c72cade334d0816f4dc39abb55d6f6f5d10dad129aeceb939c670316cc503"

  bottle do
    cellar :any_skip_relocation
    sha256 "09fcf0824843006fb9846f1f4510a0259d6f237a8b2127b7c467b3f5d52f0fd6" => :sierra
    sha256 "530477615ae3e64894730e8edacadcc51e8e8d8e6ac9e243a2ec6ef07a69b7e2" => :el_capitan
    sha256 "dfe79fdadd0dd6aba4f4570738dd31b06b0c4205b4d3e9e9c34ad1110723b444" => :yosemite
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
