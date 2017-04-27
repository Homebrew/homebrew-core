class Tensorflow < Formula
  desc "Machine Intelligence Library"
  homepage "https://tensorflow.org"
  url "https://github.com/tensorflow/tensorflow.git",
    :tag => "v0.7.1",
    :revision => "028d0b46004c921acd48fdd0ec18128d79e18bf4",
    :shallow => false

  env :std

  depends_on "bazel"
  depends_on "swig" => :build

  resource "wheel" do
    url "https://pypi.python.org/packages/source/w/wheel/wheel-0.29.0.tar.gz"
    sha256 "1ebb8ad7e26b448e9caa4773d2357849bf80ff9e313964bcaf79cbf0201a1648"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end
    ENV["PYTHON_BIN_PATH"] = which "python"
    ENV["TF_NEED_CUDA"] = "0"

    system "./configure"

    system "bazel", "build", "-c", "opt", "//tensorflow/tools/pip_package:build_pip_package"
    system "bazel-bin/tensorflow/tools/pip_package/build_pip_package", buildpath/"tensorflow_pkg"

    system "pip install --ignore-installed --user #{buildpath}/tensorflow_pkg/tensorflow-0.7.1-*.whl"
  end

  def caveats; <<-EOS.undent
    TensorFlow depends on the development version of Protobuf which cannot be installed automatically.

    To install Protobuf:
      brew install protobuf --devel

    If Protobuf is already installed but at the stable version, upgrade it with:
      brew upgrade protobuf --devel
    EOS
  end

  test do
    system "python", "-c", "import tensorflow"
  end
end
