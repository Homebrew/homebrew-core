class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "https://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.26-cutoff.tar.gz"
  sha256 "8bd41b53c3b903615d281e7277d5a9225075c3d00ea56c6e44d73f6327c73d55"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf54d4426d88d2cff21c465a7df3bbe25b6079610be947eb0613fa0760c3372b" => :catalina
    sha256 "25ce694b1f816f5004a21399d514cf44be904f8e575d8df4f0911370ac1fba19" => :mojave
    sha256 "9a4436d48d7908470727c7c4bbc9d6ed34ef45f2512646823418651f4aa6a991" => :high_sierra
    sha256 "e1509d1ec241f1d5c693ba6aeb00938fb0cbc7d7f4e92bab54d2dafdbe631849" => :sierra
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
