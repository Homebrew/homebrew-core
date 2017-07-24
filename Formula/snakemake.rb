class Snakemake < Formula
  desc "Pythonic workflow system"
  homepage "https://bitbucket.org/snakemake/snakemake/wiki/Home"
  url "https://files.pythonhosted.org/packages/0d/e1/a811fba2a04d9d86f0a8ef76882194e7ebf1b1f46fa54bd697c022296355/snakemake-4.0.0.tar.gz"
  sha256 "e027e96fc17b11882f824b7b635928ae2648b984c3041b1620b2eb5fa54d9849"
  head "https://bitbucket.org/snakemake/snakemake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b4d24d6c220b1910a0c38dd4b6365ed08266b886a5599e84ca012e6d5fd1797" => :sierra
    sha256 "8b6399f5ea337f485ac78cb1cb35cfafcd9328b98d65972e7244e46f1d9778cc" => :el_capitan
    sha256 "9123718e1153b9e775174f4370701197ace07ad5b22daa376498f952a43c92ec" => :yosemite
  end

  depends_on :python3

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2c/b5/2b6e8ef8dd18203b6399e9f28c7d54f6de7b7549853fe36d575bd31e29a7/requests-2.18.1.tar.gz"
    sha256 "c6f3bdf4a4323ac7b45d01e04a6f6c20e32a052cd04de81e05103abc049ad9b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/96/d9/40e4e515d3e17ed0adbbde1078e8518f8c4e3628496b56eb8f026a02b9e4/urllib3-1.21.1.tar.gz"
    sha256 "b14486978518ca0901a76ba973d7821047409d7f726f22156b24e83fd71382a5"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/a3/bb/525e9de0a220060394f4aa34fdf6200853581803d92714ae41fc3556e7d7/wrapt-1.10.10.tar.gz"
    sha256 "42160c91b77f1bc64a955890038e02f2f72986c01d462d53cb6cb039b995cdd9"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

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
