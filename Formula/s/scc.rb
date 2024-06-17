class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "3097e23532d9a254fe217c81557136c7ac5aa4d48a200b61b366330e5eaf7ce4"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c47ebccd16714cb51e9c6e7c257804f42b9d47e53443bed164fb521d87650cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f09208465b4f88b8f7e636205b4230dcd15c2ae822d99e9409fdf357d4220d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617b4397b1046acf9efe034ab6cda77759470314dc9028b7a9872a64ebf1ef7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dd97f35dbe4a095d3c61894715104224cc3ed2e0bc38c04b36b295c084a466a"
    sha256 cellar: :any_skip_relocation, ventura:        "7a08426edc8b2c086bbabb499bbfa735697011eab70bb213f5cd82f8978f229f"
    sha256 cellar: :any_skip_relocation, monterey:       "0777909c35d5d258b85b776e81dc48bc6d5e7b431d3f8635186633cd6045b974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2cec92a0bb037c03c302d6279e0a9f98482584a84a496cb376a77902c1c419"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
