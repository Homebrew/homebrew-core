class Sgn < Formula
  desc "Shikata ga nai (仕方がない) encoder ported into go with several improvements"
  homepage "https://github.com/EgeBalci/sgn"
  url "https://github.com/EgeBalci/sgn/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "eb5d5636e7fa701e646fd321cd47adb0ded8650af1532315ddd493aff06c4c22"
  license "MIT"
  head "https://github.com/EgeBalci/sgn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07eccdd132aee13fd1372292119fe9c0626bed3fdf0c162a2ed61e9d5e89d279"
    sha256 cellar: :any,                 arm64_sequoia: "5725e674f35d68b61e9c90b6de698aadb6e8345e4558a3b106d81e2930fa2e6c"
    sha256 cellar: :any,                 arm64_sonoma:  "3008605b7acf03e6dc9cf7fcb4b9da85d6ed3a209b0b023c5745e630c0b1182d"
    sha256 cellar: :any,                 sonoma:        "eee8805d37e8f4810277bee9468ec07bde62c9693600dadbfe3bd9c279f104f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d37bf2fe1818fce63dbccfd413bf31df69d3a4a67f899e5c2b54361ed3ac8a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa2c8e219183546fdfc6d3d60cc2441f9bd5f593c5c1ed7e3909588359fb67f"
  end

  depends_on "go" => :build
  depends_on "keystone"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux?
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/EgeBalci/sgn/config.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/sgn -i #{test_fixtures("mach/a.out")} -o #{testpath}/sgn.out")
    assert_match "All done ＼(＾O＾)／", output
  end
end
