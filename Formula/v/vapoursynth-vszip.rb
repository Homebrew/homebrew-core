class VapoursynthVszip < Formula
  desc "VapourSynth Zig Image Process"
  homepage "https://github.com/dnjulek/vapoursynth-zip"
  url "https://files.pythonhosted.org/packages/3e/5e/3823f1c3ce492c3f0acca288501e67cbd1de4be317c436c71d5fdfdd81c9/vapoursynth_vszip-22.1.0.tar.gz"
  sha256 "93c1aaf5867ad43e1f21b77418fa89b0b1ed2191d0c4bfb03a65c958826ed8c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c58bcaec57e76ced6cacf902a173c0e2207b7e23519b5175a6e821c53811514c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cee8e8d8cdf55f924693870924a639a385e77cef023b9b72303d58cb177239d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af96d35ff7f6be981ea2252c2d0bb5805837ce2ded71fc2e5bd1129dcd7e5775"
    sha256 cellar: :any_skip_relocation, sonoma:        "b635e2e928c56f1b26c6e39f3a8f21cf68c105476feb843fd1cbe7776caa63a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5612911eefe0bb06ddc2668c0e8a5dcea9fe2e03dad5a8926619fb06b1125b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c791c26b95a83720a51d55bb1c869215894a7ea0e5ebee271280ae37b17e9f"
  end

  depends_on "zig" => :build
  depends_on "python@3.14"
  depends_on "vapoursynth"

  preserve_rpath # skip unnecessary relocation for plugin which avoids headerpad errors

  deny_network_access! [:postinstall, :test]

  def python3 = "python3.14"

  def install
    plugindir = "#{Language::Python.site_packages(python3)}/vapoursynth/plugins"
    system "zig", "build", "--prefix-lib-dir", plugindir, *std_zig_args
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from vapoursynth import core
      print(core.vszip.ImageRead("#{test_fixtures("test.png")}"))
    PYTHON
    assert_match "Width: 8", shell_output("#{python3} test.py")
  end
end
