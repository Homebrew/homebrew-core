class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.20-cutoff.tar.gz"
  sha256 "60f0f312b500baf10d091496d23292ba92da67fced540cc53f25b18611188ada"

  bottle do
    cellar :any_skip_relocation
    sha256 "b95dd993ea1b1abe50ddad23cc39c7fd05d945feda2f6a1ab69494329a9ccdfc" => :el_capitan
    sha256 "445c9d68f087d8e344227e5f7e1a0b030cfe72455cad319fc7e3729dcd42b3cc" => :yosemite
    sha256 "e343bf0eee23c941209be92080ce439d0daf892169967287f9dc45f2d3a0dd61" => :mavericks
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
