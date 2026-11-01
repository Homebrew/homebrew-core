class VapoursynthVszip < Formula
  desc "VapourSynth Zig Image Process"
  homepage "https://github.com/dnjulek/vapoursynth-zip"
  url "https://files.pythonhosted.org/packages/73/15/da43c2789c6381fb98897617a7a9d9415b5fa4be198089e12900f7ee7d31/vapoursynth_vszip-24.0.0.tar.gz"
  sha256 "b2d6157228d0e786a19ac9055814e6141841ffc2c7b42ac1858b0600fc4a69cb"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42f59724273382f896d7155dce6a3dd689902a117bbf48e7b827e85814fe2fd8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e86fd962fa6e3e96da96cf9705b545f22305a97615f226d3681dd0cf540c33a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ea57078ea20485dfa311d932aefc0a876152548cd37eb442dde40d02699030d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "506ca5e7265004b889e898e3288595f65ad2b38df5f7c11e743efdba90ac3059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dc1e977b80b667927ddb8f70e2d2073ec7ee42d86249ce58ca1f5f7788502a13"
  end

  depends_on "zig" => :build
  depends_on "python@3.15"
  depends_on "vapoursynth"

  preserve_rpath # skip unnecessary relocation for plugin which avoids headerpad errors

  pypi_packages exclude_packages: "vapoursynth"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

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
