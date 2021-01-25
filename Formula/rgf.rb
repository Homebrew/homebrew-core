class Rgf < Formula
  desc "Regularized Greedy Forest library"
  homepage "https://github.com/RGF-team/rgf"
  url "https://github.com/RGF-team/rgf/archive/3.9.0.tar.gz"
  sha256 "78ccd04dfcb610094393e8463e01e6933d9ff15ed08024e6088daf7ab0e94a97"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce42712fd7c267b9df1de9e869c08b46a33227f416a7986c91bc181deaedf8b9" => :big_sur
    sha256 "ec708a6c591ac0103bafc39608b3ac287b72c67b99d25929345b727776a96b65" => :arm64_big_sur
    sha256 "6de68732658233225c9b6bac4d685e9e11a51748f140e3213dee4bbda47f0a14" => :catalina
    sha256 "4ec45f0308dbbe42ddb35ada76473f5d9cead2fb118fa5d71a5ef3a8ce684435" => :mojave
    sha256 "8887ef17fd595310b43d6ef940a28608fced9c828f012a0d991929c8d44a0ab4" => :high_sierra
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
