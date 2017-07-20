class Snakemake < Formula
  desc "Pythonic workflow system"
  homepage "https://bitbucket.org/snakemake/snakemake/wiki/Home"
  url "https://files.pythonhosted.org/packages/e5/d9/525fc2ff7c3bb6d990281188f4607f9e7651f19d9cb71a83b08aeb6b1bcf/snakemake-3.13.3.tar.gz"
  sha256 "ad5c2544adfb25704b85b0bec46fbf1d904586969cb03ff9d414924c485a3dda"
  head "https://bitbucket.org/snakemake/snakemake.git"

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
