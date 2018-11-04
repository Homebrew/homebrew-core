class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "https://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.26-cutoff.tar.gz"
  sha256 "8bd41b53c3b903615d281e7277d5a9225075c3d00ea56c6e44d73f6327c73d55"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2f8f6dde12ef90163844ddda4aba3ab3e37157b446f3b728d1863d36c21b1bc" => :mojave
    sha256 "efab24efd6b897345a5ddb3932e4aa25600feed32a2efea1b66362f29637bed7" => :high_sierra
    sha256 "76ba2152aec4e7334fbffe43f9597b0c13aca9f039d69b6d44dcf6c162b017a0" => :sierra
    sha256 "272761b8757206fe1f31f7cc6b1ea36f7a6a804f6deb06ed14873eea6f894dfe" => :el_capitan
    sha256 "7364d98e346d5bb358f26674c19116c09b5b8e48e28651e90776307d6c4398fe" => :yosemite
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8"

  def install
    system "./gradlew", "build", "-x", "test"
    libexec.install %w[lib dist contrib]
    bin.install Dir["bin/*{.sh,.py}"]
    libexec.install "bin"
    pkgshare.install "config" => "config-examples"
    (etc/"voldemort").mkpath
    env = {
      :VOLDEMORT_HOME       => libexec,
      :VOLDEMORT_CONFIG_DIR => etc/"voldemort",
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"vadmin.sh"
  end
end
