class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9b359c2c7e78d418266654e4c94988b0495ddea62391fcf51512038dd3109146"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f94e737a853bebf1ec049c3d57107aa0e794aca060281d630e49a30ec81cf076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "409b6050fa2951c94b8d066c404fa90d19550cdb5ca0fe26b0c67b4c39e1e0f8"
    sha256 cellar: :any_skip_relocation, monterey:       "ee3a97b14f93cc056cda66d0844bce846de340e495cf0ad7d7b656f61e43c372"
    sha256 cellar: :any_skip_relocation, big_sur:        "5279a5a2a5d808252a1fdcec42404f6a8f0db8642b480ac42095fe12c35b292b"
    sha256 cellar: :any_skip_relocation, catalina:       "553163efb73b54754f90d097c88932040adc607e7e94a5d529808318f0fa3c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c975aedb851d136e011fd9d44bbee9a5de9f8890585d7993556c519d1e010d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
