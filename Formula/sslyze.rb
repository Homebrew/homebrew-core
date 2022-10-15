class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/7f/48/4181eae25c2e32d9599619af8927a6d1ce60f5650656a870de1c02e065aa/sslyze-5.0.6.tar.gz"
    sha256 "b420aed4c3a527e015be10e0f5ea027b136d88c08697954867b9c6344f2ffab7"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.2.tar.gz"
      sha256 "440296e07ee021dc283bfe7b810f3139349e26445bc21b5e05820808e15186a2"

      # Combination of https://github.com/nabla-c0d3/nassl/pull/89
      # and https://github.com/nabla-c0d3/nassl/pull/97.
      # This can be removed when nassl makes a new release.
      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "142ff5441e74129005a83f067735307b9e7a2ed9607af7b12241a139a876c67b"
    sha256 cellar: :any,                 big_sur:      "e200d5cc4d35a58aa4adf83d94d28996f92fc4fc28e5c65e8f0cd876b0d335b9"
    sha256 cellar: :any,                 catalina:     "31114e3f22cdf95678b0462e544643c631dd6a7e5639071ad604979ca5bceee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f62718601c7a1b278c85fc5b6d8e4b5b02b939ef4f90d88fa799151efb8d6f3"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git", branch: "release"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git", branch: "release"
    end
  end

  depends_on "pyinvoke" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  uses_from_macos "libffi", since: :catalina

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/7d/7d/58dd62f792b002fa28cce4e83cb90f4359809e6d12db86eedf26a752895c/pydantic-1.10.2.tar.gz"
    sha256 "91b8e218852ef6007c2b98cd861601c6a09f1aa32bbbb74fab5b1c33d4a1e410"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/12/fc/282d5dd9e90d3263e759b0dfddd63f8e69760617a56b49ea4882f40a5fc5/tls_parser-2.0.0.tar.gz"
    sha256 "3beccf892b0b18f55f7a9a48e3defecd1abe4674001348104823ff42f4cbc06b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources.reject { |r| r.name == "nassl" }

    ENV.prepend_path "PATH", libexec/"bin"
    resource("nassl").stage do
      system "invoke", "build.all"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCANS COMPLETED", shell_output("#{bin}/sslyze --mozilla_config=old google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end

__END__
diff --git a/build_tasks.py b/build_tasks.py
index 7821ebdc15d63caea9dee68b039dd38fbd0d314f..c9b3cfd9870fdd61a62ea22a846b48c09320b780 100644
--- a/build_tasks.py
+++ b/build_tasks.py
@@ -314,11 +314,11 @@ def exe_path(self) -> Path:
 class ZlibBuildConfig(BuildConfig):
     @property
     def src_tar_gz_url(self) -> str:
-        return "https://zlib.net/zlib-1.2.11.tar.gz"
+        return "https://zlib.net/zlib-1.2.13.tar.gz"

     @property
     def src_path(self) -> Path:
-        return _DEPS_PATH / "zlib-1.2.11"
+        return _DEPS_PATH / "zlib-1.2.13"

     def build(self, ctx: Context) -> None:
         if self.platform in [SupportedPlatformEnum.WINDOWS_32, SupportedPlatformEnum.WINDOWS_64]:
