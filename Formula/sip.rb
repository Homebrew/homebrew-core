class Sip < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://www.riverbankcomputing.com/software/sip/intro"
  url "https://files.pythonhosted.org/packages/76/d9/5e1048d2f2fa6714e0d76382810b0fa81400c40e25b1f4f46c1a82e48364/sip-6.0.3.tar.gz"
  sha256 "929e3515428ea962003ccf6795244a5fe4fa6e2c94dc9ab8cb2c58fcd368c34c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/sip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71ce74e4246ef979c64023470b0d5d6d33cf108bbedc3d7423c410b145444971"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f80f89a34ee8addbefe89fc8a858e25f374e4bb35f989b6e00f6f5d9a91e5a1"
    sha256 cellar: :any_skip_relocation, catalina:      "e6d4c1765eee476b786dc0f4d42f207df4f44210b70874ee6ba6f7538f2cd56f"
    sha256 cellar: :any_skip_relocation, mojave:        "9381bd79e617700717fe0e915df652ec5d223171be3edf760580df1529fc2b8f"
  end

  depends_on "python@3.9"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    %w[packaging pyparsing toml].each do |r|
      venv.pip_install resource(r)
    end

    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)

    site_packages = libexec/"lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (lib/"python#{xy}/site-packages/homebrew-sip.pth").write pth_contents
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      # Specify sip v6 as the build system for the package.
      [build-system]
      requires = ["sip >=6, <7"]
      build-backend = "sipbuild.api"

      # Specify the PEP 566 metadata for the project.
      [tool.sip.metadata]
      name = "fib"
    EOS

    (testpath/"fib.sip").write <<~EOS
      // Define the SIP wrapper to the (theoretical) fib library.

      %Module(name=fib, language="C")

      int fib_n(int n);
      %MethodCode
          if (a0 <= 0)
          {
              sipRes = 0;
          }
          else
          {
              int a = 0, b = 1, c, i;

              for (i = 2; i <= a0; i++)
              {
                  c = a + b;
                  a = b;
                  b = c;
              }

              sipRes = b;
          }
      %End
    EOS

    system "sip-install", "--target-dir", "."
  end
end
