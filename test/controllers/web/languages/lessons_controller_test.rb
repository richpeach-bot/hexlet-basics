# frozen_string_literal: true

require 'test_helper'

class Web::Languages::LessonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = language_lessons(:two)
    @language = @lesson.language
    @info = @lesson.infos.last
    @user = users(:full)
  end

  test 'show' do
    get language_lesson_url(@language.slug, @lesson.slug, subdomain: @info.locale)
    assert_response :success
  end

  test 'show amp' do
    get language_lesson_url(@language.slug, @lesson.slug, subdomain: @info.locale, format: :amp)
    assert_response :success
  end

  test 'show (signed in)' do
    sign_in_as(:full)
    get language_lesson_url(@language.slug, @lesson.slug, subdomain: @info.locale)
    assert_response :success
  end

  test 'next_lesson' do
    sign_in_as(:full)
    third_language_lesson = language_lessons(:three)

    get next_lesson_language_lesson_url(@language.slug, @lesson.slug, subdomain: I18n.locale)
    assert_response :redirect

    assert_redirected_to language_lesson_url(@language.slug, third_language_lesson.slug, subdomain: I18n.locale)
  end

  test 'prev_lesson' do
    first_language_lesson = language_lessons(:one)

    get prev_lesson_language_lesson_url(@language.slug, @lesson.slug, subdomain: I18n.locale)
    assert_response :redirect

    assert_redirected_to language_lesson_url(@language.slug, first_language_lesson.slug, subdomain: I18n.locale)
  end
end
