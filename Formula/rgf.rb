class Rgf < Formula
  desc "Regularized Greedy Forest library"
  homepage "https://github.com/RGF-team/rgf"
  url "https://github.com/RGF-team/rgf/archive/3.8.0.tar.gz"
  sha256 "f21dce9b877bf802a5699ce58b1b87346337d3be838ddfe78b18cfec45813af7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "472e412b8f6af779fb7764695a5bc621bc6b9b4c2a2c3cd238944e98e8eb7d41" => :catalina
    sha256 "768ae58c3d372fdee93dd60893b83fe626be76e25e6ebb099e666e90e1bcfa21" => :mojave
    sha256 "5091b77f8e7323e7518d42ad0cbe27b0328f24c6931ed3a5e5fd85fa4828d294" => :high_sierra
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
