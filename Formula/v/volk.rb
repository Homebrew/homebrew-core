class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.2.0/volk-3.2.0.tar.gz"
  sha256 "9c6c11ec8e08aa37ce8ef7c5bcbdee60bac2428faeffb07d072e572ed05eb8cd"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f910c4f27cfbd4419f857c369337c1fcce0068b05d01391fa1f6b5d9db00055"
    sha256 cellar: :any,                 arm64_sonoma:  "7a2efd35a0db458e5afe369c40a303b561a34df77d1fae9c11378afc31d2fedf"
    sha256 cellar: :any,                 arm64_ventura: "46b4a7e08f105a3348f4ac8007b8718c76715dbc35dd2f6da818031ffef214e8"
    sha256 cellar: :any,                 sonoma:        "791c5ee148b98b0707ebe2fa57f66d6310be6ef0eeb6b16925edea23c9b92f2d"
    sha256 cellar: :any,                 ventura:       "17265b6ad8a1b44a34f0ed8a9acb52abfdc6d3021adeb44b692022cc80376200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ff379409a40837f19708efd3b69898f858a7b158726db713457bcba18c4ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a453a467d9e9fcd933395cb567e39e003e3ec7f294bd422757f209e7ba418eb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "orc"
  depends_on "python@3.13"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    # Avoid falling back to bundled cpu_features
    rm_r(buildpath/"cpu_features")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"volk_modtool", "--help"
    system bin/"volk_profile", "--iter", "10"
  end
end
