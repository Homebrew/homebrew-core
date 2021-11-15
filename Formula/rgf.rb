class Rgf < Formula
  desc "Regularized Greedy Forest library"
  homepage "https://github.com/RGF-team/rgf"
  url "https://github.com/RGF-team/rgf/archive/3.11.0.tar.gz"
  sha256 "c345b1495bc2ed421e2ef7d68357fd9683e59543c6b8136751fcaca7255effa9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "595fc89f4b885f2a287c16d6d83defde0ae43c7adcb468c09d730d4f00f9c13f"
    sha256 cellar: :any_skip_relocation, big_sur:       "1be29b1e89c907084a0182fb5f83307691d971b5efa0c1c9d58381cf655703c9"
    sha256 cellar: :any_skip_relocation, catalina:      "acd40e92b2be8576c819da3c10fd49cbbfa06d98ab83ea1c9e9ff90f2151de85"
    sha256 cellar: :any_skip_relocation, mojave:        "5a9a3bcd12b525f2cfa9be7c819a283a36a0ecbc78b96cc45fb10b3ea610e9b2"
  end

  depends_on "cmake" => :build

  def install
    cd "RGF" do
      mkdir "build" do
        system "cmake", *std_cmake_args, ".."
        system "make"
        system "make", "install" # installs to bin/rgf
      end
      bin.install "bin/rgf"
      pkgshare.install "examples"
    end
  end

  test do
    cp_r (pkgshare/"examples/sample/."), testpath
    parameters = %w[
      algorithm=RGF
      train_x_fn=train.data.x
      train_y_fn=train.data.y
      test_x_fn=test.data.x
      reg_L2=1
      model_fn_prefix=rgf.model
    ]
    output = shell_output("#{bin}/rgf train_predict #{parameters.join(",")}")
    assert_match "Generated 20 model file(s)", output
  end
end
