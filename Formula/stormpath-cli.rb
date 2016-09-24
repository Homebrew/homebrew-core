class StormpathCli < Formula
  desc "Command-line interface for https://stormpath.com/ user management"
  homepage "https://github.com/stormpath/stormpath-cli"
  url "https://github.com/stormpath/stormpath-cli/archive/0.1.1.tar.gz"
  sha256 "36b0c68127fa5f95f1440eb3f10c36a572e4c2ae54963146495a8b103dd33d34"
  head "https://github.com/stormpath/stormpath-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51bff254a1a5c6ca2427f881aa1064a86be641c4812faeb5e03cf2424c9409f1" => :el_capitan
    sha256 "c649bd0aeb2da1553c0c3be998c07a36b159ad44d7182b91a16b4ab2cb636787" => :yosemite
    sha256 "7756541509cfcc0df6433c4aeb4abacc74f8fbd009cef9e91081bcb60694abe7" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/11/21/47b5d2696a945da177d2344b6e330b7b0d1c52404063cb387d2261517ccb/cssselect-0.9.2.tar.gz"
    sha256 "713b5b99ef08022257b3409c7ae1b18b2c6536b3f155e6237c5cfba0f67ae6f5"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/f4/5b/fe03d46ced80639b7be9285492dc8ce069b841c0cebe5baacdd9b090b164/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/11/1b/fe6904151b37a0d6da6e60c13583945f8ce3eae8ebd0ec763ce546358947/lxml-3.6.0.tar.gz"
    sha256 "9c74ca28a7f0c30dca8872281b3c47705e21217c8bc63912d95c9e2a7cac6bdf"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/db/73/2a73deac557e3d2489e4aa14d606e20d6a445cd24a1f8661a6b1d26b41c6/oauthlib-1.0.3.tar.gz"
    sha256 "ef4bfe4663ca3b97a995860c0173b967ebd98033d02f38c9e1b2cbb6c191d9ad"
  end

  resource "PyDispatcher" do
    url "https://files.pythonhosted.org/packages/cd/37/39aca520918ce1935bea9c356bcbb7ed7e52ad4e31bff9b943dfc8e7115b/PyDispatcher-2.0.5.tar.gz"
    sha256 "5570069e1b1769af1fe481de6dd1d3a388492acddd2cdad7a3bde145615d5caf"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/55/88/88d9590195a7fcc947501806f79c0918d8d3cdc6f519225d4efaaf3965e8/PyJWT-1.4.0.tar.gz"
    sha256 "e1b2386cfad541445b1d43e480b02ca37ec57259fd1a23e79415b57ba5d8a694"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/e0/4c/29d89a63446a1693798c7431188b75371921de4ea1506c06159e9eca23d6/pyquery-1.2.13.tar.gz"
    sha256 "fbc95cf422ac79fa00c5107a2f33dff7dd106d6de569493bd938881b75d42e49"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stormpath" do
    url "https://files.pythonhosted.org/packages/08/00/8566ef03476112f13120569816644f3af7e8cdc7a13cb776417c520eca8e/stormpath-2.4.0.tar.gz"
    sha256 "d226aecf5535680b537a3f95fb383b19fe08312a031cb26fcb3aa3b68d1f1b66"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"stormpath", "--help"
  end
end
