require 'rubygems/test_case'
require 'rubygems/dependency_resolver'

class TestGemDependencyResolverIndexSpecification < Gem::TestCase

  def test_initialize
    set     = Gem::DependencyResolver::IndexSet.new
    source  = Gem::Source.new @gem_repo
    version = Gem::Version.new '3.0.3'

    spec = Gem::DependencyResolver::IndexSpecification.new(
      set, 'rails', version, source, Gem::Platform::RUBY)

    assert_equal 'rails',             spec.name
    assert_equal version,             spec.version
    assert_equal Gem::Platform::RUBY, spec.platform

    assert_equal source, spec.source
  end

  def test_spec
    @fetcher = Gem::FakeFetcher.new
    Gem::RemoteFetcher.fetcher = @fetcher

    a_2   = quick_spec 'a', 2
    a_2_p = quick_spec 'a', 2 do |s| s.platform = Gem::Platform.local end

    Gem::Specification.add_specs a_2, a_2_p

    util_setup_spec_fetcher a_2, a_2_p

    source = Gem::Source.new @gem_repo
    version = v 2

    set = Gem::DependencyResolver::IndexSet.new
    i_spec = Gem::DependencyResolver::IndexSpecification.new \
      set, 'a', version, source, Gem::Platform.local

    spec = i_spec.spec

    assert_equal a_2_p.full_name, spec.full_name
  end


end

