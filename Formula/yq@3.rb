class YqAT3 < Formula
  desc "Process YAML documents from the CLI - Version 3"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.1.tar.gz"
  sha256 "73259f808d589d11ea7a18e4cd38a2e98b518a6c2c178d1ec57d9c5942277cb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ff1ee3e11e18b1a3f12754f37627b9641b24db8b99cf5725bdad22352812394"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4b71750b38057dd5d5df339859fb76a945c916b666c221098b95c1dda2508c5"
    sha256 cellar: :any_skip_relocation, catalina:      "2009fa7cc5c8aaa95856a401cea51c60ba2b21b49cc5d4227aab8f290a27e760"
    sha256 cellar: :any_skip_relocation, mojave:        "4180e832dac7686fc6e0db67ebde2aa4c28dc42934795fed810e657853b47ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b984fa4e2b4aee1bdec7d7ed60ed89e2ed3b2afdaffac772a696b1f857fae6a"
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
