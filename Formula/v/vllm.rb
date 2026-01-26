class Vllm < Formula
  include Language::Python::Virtualenv

  desc "High-throughput and memory-efficient inference and serving engine for LLMs"
  homepage "https://github.com/vllm-project/vllm"
  url "https://github.com/vllm-project/vllm/releases/download/v0.13.0/vllm-0.13.0.tar.gz"
  sha256 "4ad43db45fef37114b550d03a4f423fb3fa3a31d8bc09ee810ef8b9cdcd4b5fe"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "pytorch"

  # Build dependencies required by vllm's pyproject.toml
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/7b/b1/19587742aad604f1988a8a362e660e8c3ac03adccdb71c96d86526e5eb62/setuptools_scm-9.2.2.tar.gz"
    sha256 "1c674ab4665686a0887d7e24c03ab25f24201c213e82ea689d2f3e169ef7ef57"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/8a/98/2d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25c/wheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  def install
    python3 = "python3.13"
    venv = virtualenv_create(libexec, python3)

    # Link to the pytorch formula via a .pth file
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents

    # Install build dependencies first (required for build_isolation: false)
    venv.pip_install resources

    # Patch Python version requirements to allow Python 3.13 (upstream only supports <3.14 currently)
    inreplace buildpath/"pyproject.toml", 'requires-python = ">=3.12,<3.14"', 'requires-python = ">=3.12,<3.14"'
    inreplace buildpath/"CMakeLists.txt",
              'set(PYTHON_SUPPORTED_VERSIONS "3.12" "3.13")',
              'set(PYTHON_SUPPORTED_VERSIONS "3.12" "3.13")'

    # Disable ARM BF16 support on macOS - Apple's clang has incomplete BF16 intrinsics support
    inreplace buildpath/"cmake/cpu_extension.cmake",
              'check_sysctl(hw.optional.arm.FEAT_BF16 ARM_BF16_FOUND)',
              'set(ARM_BF16_FOUND FALSE) # Disabled: Apple clang BF16 intrinsics incomplete'

    # Install vllm with CPU support by default to ensure compatibility on systems without GPUs
    ENV["VLLM_TARGET_DEVICE"] = "cpu"

    # Environment variables for CPU-only build to avoid CUDA dependencies
    ENV["FORCE_CPU"] = "1"
    ENV["USE_CUDA"] = "0"
    ENV["VLLM_INSTALL_HIP"] = "0"
    ENV["VLLM_USE_TRITON"] = "0"

    # Limit parallel jobs to prevent resource exhaustion during build
    max_jobs = ENV.make_jobs.to_i
    max_jobs = [max_jobs, 4].min if max_jobs.positive?
    ENV["MAX_JOBS"] = max_jobs.to_s
    ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = max_jobs.to_s

    # Build configuration
    ENV["RUST_BACKTRACE"] = "1"
    ENV["CARGO_NET_RETRY"] = "10"
    ENV["CARGO_NET_GIT_FETCH_WITH_CLI"] = "true"

    # Use system cmake
    ENV["SKBUILD_CMAKE_EXECUTABLE"] = Formula["cmake"].opt_bin/"cmake"
    ENV["CMAKE_PREFIX_PATH"] = Formula["cmake"].opt_prefix

    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    # Test that vllm can be imported and version is accessible
    # Note: Full functionality requires additional runtime dependencies
    system libexec/"bin/python", "-c", <<~PYTHON
      import vllm
      version = vllm.__version__
      print(f"vllm version: {version}")
      assert version == "0.13.0", f"Unexpected version: {version}"
    PYTHON
  end
end
