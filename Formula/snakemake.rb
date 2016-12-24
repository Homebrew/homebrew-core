class Snakemake < Formula
  desc "Pythonic workflow system"
  homepage "https://bitbucket.org/snakemake/snakemake/wiki/Home"
  url "https://pypi.python.org/packages/source/s/snakemake/snakemake-3.5.5.tar.gz"
  sha256 "1f13667fd0dea7d2f35414399646288b8aece2cf9791566992001d95d123eb1b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5e704fdac3d9d79ae578884741ff66f344e2572ffdb0f7cbc769be4c4c9eaf5e" => :sierra
    sha256 "05075c4f2ba8c196179c5cdc27eeff98f6b27c90d27ba4ca7989404f535f4343" => :el_capitan
    sha256 "05075c4f2ba8c196179c5cdc27eeff98f6b27c90d27ba4ca7989404f535f4343" => :yosemite
  end

  depends_on :python3

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Snakefile").write <<-EOS.undent
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    system "#{bin}/snakemake"
  end
end
