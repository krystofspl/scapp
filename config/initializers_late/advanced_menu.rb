require 'advanced_menu/advanced_menu'
AdvancedMenu::Menu.setup do |config|
  config.name = 'name'

  config.add_heading(I18n.t('nav.user'), '#', nil, nil, nil, AdvancedMenu::ROLES, %w(fa fa-angle-double-right)) do |h|
    h.add_link(I18n.t('nav.users'), '/users', 'users', 'index', %w(fa fa-users))
    h.add_link(I18n.t('nav.new_user'), '/users/new','users', 'new', %w(fa fa-plus), [:admin])
    h.add_link(I18n.t('nav.my_groups'), '/users/{user_slug}/groups', 'user_groups', 'user_in', %w(fa fa-group), [:player, :coach, :admin])
    h.add_link(I18n.t('nav.my_relations'), '/users/{user_slug}/relations', 'user_relations', 'user_has', %w(fa fa-random))
    h.add_link(I18n.t('nav.groups'), '/user_groups', 'user_groups', nil, %w(fa fa-users), [:player, :coach, :admin])
    h.add_link(I18n.t('nav.new_group'), '/user_groups/new', 'user_groups', 'new', %w(fa fa-plus), [:coach, :admin])
    h.add_link(I18n.t('nav.relations'), '/user_relations', 'user_relations', nil, %w(fa fa-random), :admin)
    # h.add_link('New relation', '/relations/new', %w(fa fa-plus) :admin)
  end

  config.add_heading(I18n.t('nav.variable_fields'), '#', nil, nil, nil, AdvancedMenu::ROLES, %w(fa fa-angle-double-right)) do |h|
    h.add_link(I18n.t('nav.my_variable_fields'), "/users/{user_slug}/variable_fields", 'variable_fields',
               'user_variable_field', %w(fa fa-bar-chart-o),[:player, :coach, :admin])
    h.add_link(I18n.t('nav.new_variable_field'), '/variable_fields/new', 'variable_fields', 'new', %w(fa fa-plus), [:player, :coach, :admin])
    h.add_link(I18n.t('nav.variable_field_measurements'), '/variable_field_measurements', 'variable_field_measurements',
               'index', %w('fa fa-clock-o'), [:coach, :admin])
    h.add_link(I18n.t('nav.variable_field_categories'), '/variable_field_categories', 'variable_field_categories',
               nil, %w(fa fa-folder-o))
    h.add_link(I18n.t('nav.new_variable_field_category'), '/variable_field_categories/new', 'variable_field_categories',
               'new', %w(fa fa-plus), [:player, :coach, :admin])
    # TODO implement
    # h.add_link(I18n.t('nav.variable_field_user_levels'), '/variable_field_user_levels', 'variable_field_user_levels',
    #            nil, %w(fa fa-signal), [:coach, :admin])
    # h.add_link(I18n.t('nav.new_variable_field_user_level'), '/variable_field_user_levels/new',
    #            'variable_field_user_level', 'new', %w(fa fa-plus), [:admin])
    # h.add_link(I18n.t('nav.variable_field_sports'), '/variable_field_sports', 'variable_field_sports', nil,
    #            %w(fa fa-heart-o), [:coach, :admin])
    # h.add_link(I18n.t('nav.new_variable_field_sport'), '/variable_field_sports', 'variable_field_sports', 'new',
    #            %w(fa fa-plus), [:admin])
  end

  config.add_heading(I18n.t('nav.trainings'), '#', nil, nil, nil, AdvancedMenu::ROLES, %w(fa fa-angle-double-right)) do |h|
    h.add_link(I18n.t('nav.my_trainings'), "/users/{user_slug}/trainings", 'regular_trainings', 'user_regular_trainings',
              %w(fa fa-table))
    h.add_link(I18n.t('nav.regular_trainings'), '/regular_trainings', 'regular_trainings', 'index', %w(fa fa-table), [:coach, :admin])
    h.add_link(I18n.t('nav.new_training'), '/regular_trainings/new', 'regular_trainings', 'new', %w(fa fa-plus), [:coach, :admin])
    h.add_link(I18n.t('nav.new_lesson'), '/scheduled_lessons/new', 'training_lesson_realization', 'new', %w(fa fa-plus), [:coach, :admin])

  end

  config.add_heading(I18n.t('nav.exercises'), '#', nil, nil, nil, AdvancedMenu::ROLES, %w(fa fa-angle-double-right)) do |h|
    h.add_link(I18n.t('nav.my_exercises'), "/users/{user_slug}/exercises", 'exercises', 'user_exercises', %w(fa fa-table))
    h.add_link(I18n.t('nav.available_exercises'), "/exercises", 'exercises', 'index', %w(fa fa-table))
    h.add_link(I18n.t('nav.new_exercise'), "/exercises/new", 'exercises', 'new', %w(fa fa-plus), [:coach, :admin])
  end

  config.add_heading(I18n.t('nav.exercise_bundles'), '#', nil, nil, nil, AdvancedMenu::ROLES, %w(fa fa-angle-double-right)) do |h|
    h.add_link(I18n.t('nav.my_exercise_bundles'), "/users/{user_slug}/exercise_bundles", 'exercise_bundles', 'user_exercise_bundles', %w(fa fa-table))
    h.add_link(I18n.t('nav.available_exercise_bundles'), "/exercise_bundles", 'exercise_bundles', 'index', %w(fa fa-table))
    h.add_link(I18n.t('nav.new_exercise_bundle'), "/exercise_bundles/new", 'exercise_bundles', 'new', %w(fa fa-plus), [:coach, :admin])
  end

  config.add_heading(I18n.t('nav.finance'), '#', nil, nil, nil, [:admin], %w(fa fa-angle-double-right)) do |h|
    h.add_link(I18n.t('nav.vats'), '/vats', 'vats', 'index', %w(fa fa-money))
    h.add_link(I18n.t('nav.new_vat'), '/vats/new', 'vats', 'new', %w(fa fa-plus))
    h.add_link(I18n.t('nav.currencies'), '/currencies', 'currencies', 'index', %w(fa fa-dollar))
    h.add_link(I18n.t('nav.new_currency'), '/currencies/new', 'currencies', 'new', %w(fa fa-plus))
  end

  config.add_heading(I18n.t('nav.help'), '/help/{locale}/index', 'helps', 'index', nil, AdvancedMenu::ROLES, %w(fa fa-question)) do |h|
  end

end