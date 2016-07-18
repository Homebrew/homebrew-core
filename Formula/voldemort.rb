class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.18-cutoff.tar.gz"
  sha256 "a51fd1a53adb36a3fc70617ae5cd05ed31892a64074dfb612bb4a78aae28ecf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "25b74ad329b7ebf6f49220281503081ba374bb136948a1dc1817a03ebef09608" => :el_capitan
    sha256 "9c1cf115a4fa83bd6d4f3d161b2290ac5416751850dd882ac5b06c21a2d9a884" => :yosemite
    sha256 "db6c54af16bfb881914e38ef90d2ce906a64c6f210a90ed03279c66c6e396a05" => :mavericks
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
