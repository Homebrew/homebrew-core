class Rgf < Formula
  desc "Regularized Greedy Forest library"
  homepage "https://github.com/RGF-team/rgf"
  url "https://github.com/RGF-team/rgf/archive/3.10.0.tar.gz"
  sha256 "e2cd1f0c8e3a23a4b5a06e0cf7dade27b0d390a4682c67f450877b945126aebc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "521b1290a8f4c1df387d6a5154ee17cfeb4135b0bc29daffc8233b5d6e050e4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "88ea31516318953101add3d40fee31904651b93b27b1050650b9ce234ed7c867"
    sha256 cellar: :any_skip_relocation, catalina:      "8183722939081f3a0fc2d55ced41d873fb77e0fb00573713c9aac0e935e952c8"
    sha256 cellar: :any_skip_relocation, mojave:        "157d6024686c5333c2789b0f40fe3aa7bbaf5341b39c9ee8fe0654db45543a74"
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
