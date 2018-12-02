class Theharvester < Formula
  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/v3.0.1.tar.gz"
  sha256 "0e19a2f18459c9902792648b5fd65449c8702e61094fbb34edeed02bb8899af4"
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dea5bd671b9024d0668cb6c29e69f9cc75fdbe98d706959891fc2a1097ea800b" => :mojave
    sha256 "834e9cc62f3ac842c9ee7ddefe26930d406eb6c7b45dc121378575b624e4af9c" => :high_sierra
    sha256 "834e9cc62f3ac842c9ee7ddefe26930d406eb6c7b45dc121378575b624e4af9c" => :sierra
  end

  depends_on "python"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b pgp 2>&1")
    assert_match "security@brew.sh", output
  end
end
