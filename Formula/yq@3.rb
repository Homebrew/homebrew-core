class YqAT3 < Formula
  desc "Process YAML documents from the CLI - Version 3"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.1.tar.gz"
  sha256 "73259f808d589d11ea7a18e4cd38a2e98b518a6c2c178d1ec57d9c5942277cb1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4b71750b38057dd5d5df339859fb76a945c916b666c221098b95c1dda2508c5" => :big_sur
    sha256 "6ff1ee3e11e18b1a3f12754f37627b9641b24db8b99cf5725bdad22352812394" => :arm64_big_sur
    sha256 "2009fa7cc5c8aaa95856a401cea51c60ba2b21b49cc5d4227aab8f290a27e760" => :catalina
    sha256 "4180e832dac7686fc6e0db67ebde2aa4c28dc42934795fed810e657853b47ab2" => :mojave
  end

  keg_only :versioned_formula

  disable! date: "2021-08-01", because: :unmaintained

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args, "-o", bin/"yq"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
