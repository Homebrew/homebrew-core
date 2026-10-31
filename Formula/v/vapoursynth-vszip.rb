class VapoursynthVszip < Formula
  desc "VapourSynth Zig Image Process"
  homepage "https://github.com/dnjulek/vapoursynth-zip"
  url "https://files.pythonhosted.org/packages/73/15/da43c2789c6381fb98897617a7a9d9415b5fa4be198089e12900f7ee7d31/vapoursynth_vszip-24.0.0.tar.gz"
  sha256 "b2d6157228d0e786a19ac9055814e6141841ffc2c7b42ac1858b0600fc4a69cb"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd810cd37b335772be7ea9219e240146ad4baad213fb2d22a287bfcb574817ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc02aee7ae5724a476a6f96b315172c496f8626d300bbea6bf5ec5ea8854c544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87443a9d918b108e0f691dcaf9417d1dc9e7d638ac4ea11d55a8d407d2ce11ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4be4f576c338877ca9fd323cc91ac063c497eba746cb493d3fbab46f2923f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8d8f14caf5709ff7995fb2cc5c8f61ea3f6f4b94f8ee80d4138f1a7cd70e0f2e"
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
