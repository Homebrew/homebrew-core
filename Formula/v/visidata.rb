class Visidata < Formula
  include Language::Python::Virtualenv

  desc "Terminal spreadsheet multitool for discovering and arranging data"
  homepage "https://www.visidata.org/"
  url "https://files.pythonhosted.org/packages/06/5a/40f0546a4a2525b30df9d157719cb072b390fde4dc8e5cff06d5b8605871/visidata-3.2.tar.gz"
  sha256 "7a81ea28beefd8681bca573a056f9184c244ba79dc184a764cd8cf26919113e2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e10f52017aa69ff7852f4a1d6f4457574af0fb95432fd5663bc0fb6d13d4d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e10f52017aa69ff7852f4a1d6f4457574af0fb95432fd5663bc0fb6d13d4d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65e10f52017aa69ff7852f4a1d6f4457574af0fb95432fd5663bc0fb6d13d4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9838d4f2233f38b98ca2e10213a060ba694750d370cb213fcc6f9e6b83e7609"
    sha256 cellar: :any_skip_relocation, ventura:       "c9838d4f2233f38b98ca2e10213a060ba694750d370cb213fcc6f9e6b83e7609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e10f52017aa69ff7852f4a1d6f4457574af0fb95432fd5663bc0fb6d13d4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e10f52017aa69ff7852f4a1d6f4457574af0fb95432fd5663bc0fb6d13d4d9"
  end

  depends_on "python@3.13"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "standard-mailcap" do
    url "https://files.pythonhosted.org/packages/53/e8/672bd621c146b89667a2bfaa58a1384db13cdd62bb7722ddb8d672bf7a75/standard_mailcap-3.13.0.tar.gz"
    sha256 "19ed7955dbeaccb35e8bb05b2b5443ce55c1f932a8cbe7a5c13d42f9db4f499a"
  end

  # add missing requirements.txt, upstream pr ref, https://github.com/saulpw/visidata/pull/2789
  patch :DATA

  def install
    virtualenv_install_with_resources

    man1.install "visidata/man/visidata.1", "visidata/man/vd.1"
  end

  test do
    %w[vd visidata].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,42
      Bob,34
    CSV

    assert_match "age", shell_output("#{bin}/vd -b -f csv test.csv")
  end
end

__END__
diff --git a/requirements.txt b/requirements.txt
new file mode 100644
index 0000000..c157c88
--- /dev/null
+++ b/requirements.txt
@@ -0,0 +1,59 @@
+python-dateutil     # date type
+
+# optional dependencies
+pandas>=1.5.3; python_version >= '3.11' # dta (Stata)
+pandas>=1.0.5; python_version < '3.11'  # dta (Stata)
+requests            # http
+lxml                # html/xml
+openpyxl>= 2.4      # xlsx
+xlrd                # xls
+xlwt                # xls
+h5py                # hdf5
+psycopg2-binary     # postgres
+boto3               # rds
+pyshp               # shapefiles
+mapbox-vector-tile  # mbtiles
+pypng               # png
+fonttools           # ttf/otf
+sas7bdat            # sas7bdat (SAS)
+xport>=3            # xpt (SAS)
+PyYAML>=5.1         # yaml/yml
+dpkt                # pcap
+dnslib              # pcap
+namestand           # graphviz
+datapackage         # frictionless .json
+pdfminer.six        # pdf
+tabula              # pdf tables
+vobject             # vcf
+tabulate            # tabulate saver
+wcwidth             # tabulate saver with unicode
+zstandard           # read .zst files
+odfpy               # ods (OpenDocument)
+urllib3             # .zip over http
+pyarrow>=14.0.1; python_version >= '3.8' # arrow arrows parquet (Apache Arrow)
+pyarrow_hotfix; python_version <= '3.7' # pyarrow security patch
+pyarrow; python_version <= '3.7'
+seaborn             # plot via seaborn
+matplotlib          # svg saver
+sh                  # ping
+psutil              # procmgr
+numpy               # npy pandas hdf5 arrow
+tomli; python_version < '3.11' # toml
+pyconll             # conll/conllu
+backports.zoneinfo; python_version < '3.9' #f5log
+msgpack             # msgpack
+brotli              # msgpackz
+fecfile             # fec Federal Election Commission
+
+requests_cache      # scraper
+beautifulsoup4      # scraper
+
+Faker               # fake data generation
+
+praw                # reddit API
+matrix_client       # matrix API
+zulip               # zulip API
+pyairtable          # airtable API
+
+-e git+https://github.com/saulpw/pyxlsb.git@visidata#egg=pyxlsb                 # xlsb
+-e git+https://github.com/anjakefala/savReaderWriter#egg=savReaderWriter        # sav (SPSS)
